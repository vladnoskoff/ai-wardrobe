from fastapi import APIRouter, Depends, HTTPException, File, UploadFile
from sqlalchemy.orm import Session
import models, schemas
from database import get_db
import shutil
import os
from datetime import datetime

router = APIRouter(prefix="/clothes", tags=["Clothes"])

# Путь к папке для хранения изображений
UPLOAD_DIR = "/www/wwwroot/test.noskov-steam.ru/chkaf/clothes_images"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@router.post("/upload-image/")
async def upload_image(file: UploadFile = File(...)):
    try:
        timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
        filename = f"{timestamp}_{file.filename}"
        file_path = os.path.join(UPLOAD_DIR, filename)

        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        url = f"http://test.noskov-steam.ru/clothes_images/{filename}"
        return {"image_url": url}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Ошибка при загрузке файла: {str(e)}")

@router.post("/", response_model=schemas.ClothesResponse)
def add_clothes(clothes: schemas.ClothesCreate, db: Session = Depends(get_db)):
    new_clothes = models.Clothes(
        user_id=1,  # Заглушка, заменяется на реального пользователя при аутентификации
        name=clothes.name,
        category=clothes.category,
        season=clothes.season,
        color=clothes.color,
        material=clothes.material,
        image_url=clothes.image_url
    )
    db.add(new_clothes)
    db.commit()
    db.refresh(new_clothes)
    return new_clothes

@router.get("/", response_model=list[schemas.ClothesResponse])
def get_all_clothes(db: Session = Depends(get_db)):
    return db.query(models.Clothes).all()

@router.get("/{clothes_id}", response_model=schemas.ClothesResponse)
def get_clothes(clothes_id: int, db: Session = Depends(get_db)):
    clothes = db.query(models.Clothes).filter(models.Clothes.id == clothes_id).first()
    if not clothes:
        raise HTTPException(status_code=404, detail="Одежда не найдена")
    return clothes

@router.delete("/{clothes_id}")
def delete_clothes(clothes_id: int, db: Session = Depends(get_db)):
    clothes = db.query(models.Clothes).filter(models.Clothes.id == clothes_id).first()
    if not clothes:
        raise HTTPException(status_code=404, detail="Одежда не найдена")
    db.delete(clothes)
    db.commit()
    return {"message": "Одежда удалена"}
