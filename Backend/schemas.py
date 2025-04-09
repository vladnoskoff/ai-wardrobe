from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime


class UserCreate(BaseModel):
    name: str
    email: str
    password: str
    openai_api_key: str = None
    weather_api_key: str = None

class UserResponse(BaseModel):
    id: int
    name: str
    email: str
    openai_api_key: str = None
    weather_api_key: str = None

    class Config:
        from_attributes = True

class ClothesCreate(BaseModel):
    name: str
    category: str
    season: str
    color: str
    material: Optional[str] = None
    image_url: Optional[str] = None

class ClothesResponse(ClothesCreate):
    id: int
    user_id: int
    created_at: datetime

    class Config:
        from_attributes = True

class WeatherCreate(BaseModel):
    temperature: int
    humidity: int
    condition: str
    wind_speed: Optional[int] = None

class WeatherResponse(WeatherCreate):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True

class OutfitCreate(BaseModel):
    user_id: int
    weather_id: int
    clothing_ids: List[int]

class OutfitResponse(OutfitCreate):
    id: int
    created_at: datetime
    rating: Optional[int] = None

    class Config:
        from_attributes = True

class WearHistoryResponse(BaseModel):
    id: int
    user_id: int
    clothing_id: int
    worn_at: datetime

    class Config:
        from_attributes = True
