from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
import models, schemas
from database import get_db

router = APIRouter(prefix="/outfits", tags=["Outfits"])

@router.get("/{user_id}/{city}", response_model=schemas.OutfitResponse)
def get_outfit(user_id: int, city: str, db: Session = Depends(get_db)):
    """
    Получение наряда пользователя в зависимости от погоды в городе.

    - **user_id**: Идентификатор пользователя.
    - **city**: Название города для получения данных о погоде.

    Получает текущие погодные данные и на основе этого подбирает подходящую одежду 
    из гардероба пользователя.
    """
    # Получаем последние погодные данные
    weather = db.query(models.Weather).order_by(models.Weather.created_at.desc()).first()
    if not weather:
        raise HTTPException(status_code=404, detail="Данные о погоде отсутствуют")

    # Получаем вещи пользователя
    suitable_clothes = db.query(models.Clothes).filter(models.Clothes.user_id == user_id).all()
    selected_clothes = [c for c in suitable_clothes if c.category in ["футболка", "куртка", "штаны"]]

    if not selected_clothes:
        raise HTTPException(status_code=404, detail="Нет подходящей одежды")

    # Создаём наряд
    outfit = models.Outfit(
        user_id=user_id,
        weather_id=weather.id,
        clothing_ids=[c.id for c in selected_clothes]
    )
    db.add(outfit)
    db.commit()
    db.refresh(outfit)

    return outfit

@router.get("/history/{user_id}", response_model=list[schemas.OutfitResponse])
def get_outfit_history(user_id: int, db: Session = Depends(get_db)):
    """
    Получение истории нарядов пользователя.

    - **user_id**: Идентификатор пользователя.

    Получает историю нарядов пользователя на основе ранее сохраненных данных.
    """
    outfits = db.query(models.Outfit).filter(models.Outfit.user_id == user_id).order_by(models.Outfit.created_at.desc()).all()
    if not outfits:
        raise HTTPException(status_code=404, detail="История нарядов пуста")
    return outfits
    
@router.put("/rate/{outfit_id}")
def rate_outfit(outfit_id: int, rating: int, db: Session = Depends(get_db)):
    """
    Оценка наряда.

    - **outfit_id**: Идентификатор наряда.
    - **rating**: Оценка от 1 до 5 для наряда.

    Обновляет рейтинг наряда, если он существует.
    """
    if rating < 1 or rating > 5:
        raise HTTPException(status_code=400, detail="Рейтинг должен быть от 1 до 5")

    outfit = db.query(models.Outfit).filter(models.Outfit.id == outfit_id).first()
    if not outfit:
        raise HTTPException(status_code=404, detail="Наряд не найден")

    outfit.rating = rating
    db.commit()
    return {"message": "Рейтинг обновлён", "rating": rating}
