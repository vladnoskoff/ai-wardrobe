import requests
from fastapi import APIRouter, Depends, HTTPException, status, Response
from sqlalchemy.orm import Session
import models, schemas
from database import get_db
import settings
import json
from decimal import Decimal


router = APIRouter(prefix="/weather", tags=["Weather"])

OPENWEATHER_API_KEY = settings.OPENWEATHER_API_KEY
WEATHER_API_URL = "http://api.openweathermap.org/data/2.5/weather"

@router.get("/{city}")
def get_weather(city: str, db: Session = Depends(get_db)):
    """Получение погоды из OpenWeather API и сохранение в БД по названию города"""
    params = {"q": city, "appid": OPENWEATHER_API_KEY, "units": "metric", "lang": "ru"}
    response = requests.get(WEATHER_API_URL, params=params)
    
    if response.status_code != 200:
        raise HTTPException(status_code=400, detail="Ошибка при получении данных о погоде")

    data = response.json()
    
    # Преобразование данных в float перед сохранением
    temperature = float(data["main"]["temp"])
    humidity = int(data["main"]["humidity"])
    condition = data["weather"][0]["description"]
    wind_speed = float(data["wind"]["speed"])

    weather = models.Weather(
        temperature=temperature,
        humidity=humidity,
        condition=condition,
        wind_speed=wind_speed
    )

    db.add(weather)
    db.commit()
    db.refresh(weather)

    # Отправка данных в формате JSON с указанием кодировки utf-8
    response_json = {
        "temperature": temperature,
        "humidity": humidity,
        "condition": condition,
        "wind_speed": wind_speed
    }
    
    return Response(content=json.dumps(response_json, ensure_ascii=False), media_type="application/json; charset=utf-8")

@router.get("/coordinates", response_model=schemas.WeatherResponse)
def get_weather_by_coordinates(lat: float, lon: float, db: Session = Depends(get_db)):
    """Получение погоды по географическим координатам (широта и долгота) из OpenWeather API и сохранение в БД"""

    # Печать состояния запроса в лог
    print(f"Запрос с координатами: Широта = {lat}, Долгота = {lon}")
    
    params = {
        "lat": lat,
        "lon": lon,
        "appid": OPENWEATHER_API_KEY,
        "units": "metric",  # Температура в Цельсиях
        "lang": "ru"
    }

    # Отправка запроса на OpenWeather API
    try:
        response = requests.get(WEATHER_API_URL, params=params)

        # Если получен неверный статус от API, выбрасываем ошибку
        if response.status_code != 200:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST, 
                detail=f"Ошибка при получении данных о погоде: {response.text}"
            )

        # Получаем данные о погоде
        data = response.json()
        print(f"Полученные данные о погоде: {data}")

        weather = models.Weather(
            temperature=int(data["main"]["temp"]),  # Приводим к int
            humidity=data["main"]["humidity"],
            condition=data["weather"][0]["description"],
            wind_speed=int(data["wind"]["speed"])  # Приводим к int
        )

        # Сохраняем данные о погоде в БД
        db.add(weather)
        db.commit()
        db.refresh(weather)

        # Возвращаем данные с успешным статусом
        return weather

    except requests.exceptions.RequestException as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
            detail=f"Ошибка запроса к API: {str(e)}"
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
            detail=f"Неизвестная ошибка: {str(e)}"
        )