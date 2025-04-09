import openai
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
import models
from database import get_db
import settings

router = APIRouter(prefix="/ai", tags=["AI Recommendations"])

openai.api_key = settings.OPENAI_API_KEY

@router.get("/recommendation/{user_id}")
def ai_recommendation(user_id: int, db: Session = Depends(get_db)):
    """Анализ истории нарядов и рекомендации по улучшению"""
    outfits = db.query(models.Outfit).filter(models.Outfit.user_id == user_id).order_by(models.Outfit.created_at.desc()).limit(10).all()
    if not outfits:
        raise HTTPException(status_code=404, detail="История нарядов пуста")

    clothing_dict = {}
    for outfit in outfits:
        clothing_items = db.query(models.Clothes).filter(models.Clothes.id.in_(outfit.clothing_ids)).all()
        clothing_info = [f"{item.name} ({item.category}, {item.color}, {item.material}, {item.season})" for item in clothing_items]
        clothing_dict[outfit.id] = ", ".join(clothing_info)

    prompt = "Проанализируй мои наряды и предложи улучшения с учетом цвета, материала и сезона:\n"
    for outfit_id, description in clothing_dict.items():
        prompt += f"- Наряд {outfit_id}: {description}\n"

    response = openai.ChatCompletion.create(
        model="gpt-4",
        messages=[
            {"role": "system", "content": "Ты эксперт по моде. Анализируй цветовую сочетаемость, сезонность и ткани."},
            {"role": "user", "content": prompt}
        ]
    )

    return {"recommendation": response["choices"][0]["message"]["content"]}

@router.get("/visual-recommendation/{user_id}")
def generate_visual_outfit(user_id: int, db: Session = Depends(get_db)):
    """Генерация изображения наряда с DALL·E"""
    outfit = db.query(models.Outfit).filter(models.Outfit.user_id == user_id).order_by(models.Outfit.created_at.desc()).first()
    if not outfit:
        raise HTTPException(status_code=404, detail="Нет сохраненных нарядов")

    clothing_items = db.query(models.Clothes).filter(models.Clothes.id.in_(outfit.clothing_ids)).all()
    if not clothing_items:
        raise HTTPException(status_code=404, detail="Нет доступных вещей для наряда")

    prompt = "Создай реалистичное изображение манекена, одетого в следующий наряд:\n"
    for item in clothing_items:
        prompt += f"- {item.name} ({item.category}, {item.color}, {item.material})\n"

    response = openai.Image.create(
        prompt=prompt,
        n=1,
        size="1024x1024"
    )

    image_url = response["data"][0]["url"]
    return {"image_url": image_url}
