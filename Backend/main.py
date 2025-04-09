from fastapi import FastAPI, HTTPException, Depends, Body, APIRouter
import models
from database import engine
from routes import users, clothes, outfits, weather, ai_recommendation, wardrobe_analytics, esp_display
from fastapi.middleware.cors import CORSMiddleware

models.Base.metadata.create_all(bind=engine)

app = FastAPI()

# Разрешаем CORS для всех источников
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Разрешаем все источники, измените по мере необходимости
    allow_credentials=True,
    allow_methods=["*"],  # Разрешаем все методы (GET, POST и т. д.)
    allow_headers=["*"],  # Разрешаем все заголовки
)

app.include_router(users.router)
app.include_router(clothes.router)
app.include_router(outfits.router)
app.include_router(weather.router)
app.include_router(ai_recommendation.router)
app.include_router(wardrobe_analytics.router)
app.include_router(esp_display.router)

@app.get("/")
def read_root():
    return {"message": "Smart Closet API is running!"}
