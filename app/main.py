# app/main.py

from typing import List

from fastapi import FastAPI, Depends, HTTPException, status, Request, Form
from fastapi.templating import Jinja2Templates
from sqlalchemy.orm import Session

from .database import Base, engine, get_db
from . import models, schemas


Base.metadata.create_all(bind=engine)

app = FastAPI(title="Caregivers Platform - CRUD App")


templates = Jinja2Templates(directory="app/templates")




@app.get("/")
def read_root(request: Request):
    return templates.TemplateResponse("home.html", {"request": request})


@app.post("/users/", response_model=schemas.UserOut, status_code=status.HTTP_201_CREATED)
def create_user(user_in: schemas.UserCreate, db: Session = Depends(get_db)):
    try:
        existing = db.query(models.User).filter(models.User.email == user_in.email).first()
        if existing:
            raise HTTPException(status_code=400, detail="Email already registered")

        user = models.User(
            email=user_in.email,
            given_name=user_in.given_name,
            surname=user_in.surname,
            city=user_in.city,
            phone_number=user_in.phone_number,
            profile_description=user_in.profile_description,
            password=user_in.password,
        )
        db.add(user)
        db.commit()
        db.refresh(user)
        return user

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Create user error: {e}")



@app.get("/users/", response_model=List[schemas.UserOut])
def list_users(db: Session = Depends(get_db)):
    return db.query(models.User).all()



@app.get("/users/html")
def users_html(request: Request, db: Session = Depends(get_db)):
    users = db.query(models.User).all()
    return templates.TemplateResponse(
        "users.html",
        {"request": request, "users": users},
    )


@app.post("/users/html")
def create_user_html(
    request: Request,
    email: str = Form(...),
    given_name: str = Form(...),
    surname: str = Form(...),
    city: str = Form(None),
    phone_number: str = Form(None),
    profile_description: str = Form(None),
    password: str = Form(...),
    db: Session = Depends(get_db),
):
    
    existing = db.query(models.User).filter(models.User.email == email).first()
    if not existing:
        user = models.User(
            email=email,
            given_name=given_name,
            surname=surname,
            city=city,
            phone_number=phone_number,
            profile_description=profile_description,
            password=password,
        )
        db.add(user)
        db.commit()

    users = db.query(models.User).all()
    return templates.TemplateResponse(
        "users.html",
        {"request": request, "users": users},
    )

@app.get("/users/{user_id}", response_model=schemas.UserOut)
def get_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.user_id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user


@app.put("/users/{user_id}", response_model=schemas.UserOut)
def update_user(user_id: int, user_update: schemas.UserUpdate, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.user_id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    for field, value in user_update.dict(exclude_unset=True).items():
        setattr(user, field, value)

    db.commit()
    db.refresh(user)
    return user


@app.delete("/users/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.user_id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    db.delete(user)
    db.commit()
    return None


@app.post("/caregivers/", response_model=schemas.CaregiverOut, status_code=status.HTTP_201_CREATED)
def create_caregiver(cg_in: schemas.CaregiverCreate, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.user_id == cg_in.caregiver_user_id).first()
    if not user:
        raise HTTPException(status_code=400, detail="User does not exist")

    caregiver = models.Caregiver(
        caregiver_user_id=cg_in.caregiver_user_id,
        caregiving_type=cg_in.caregiving_type,
        hourly_rate=cg_in.hourly_rate,
        photo=cg_in.photo,
        gender=cg_in.gender,
    )
    db.add(caregiver)
    db.commit()
    db.refresh(caregiver)
    return caregiver


@app.get("/caregivers/", response_model=List[schemas.CaregiverOut])
def list_caregivers(db: Session = Depends(get_db)):
    return db.query(models.Caregiver).all()

@app.post("/members/", response_model=schemas.MemberOut, status_code=status.HTTP_201_CREATED)
def create_member(m_in: schemas.MemberCreate, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.user_id == m_in.member_user_id).first()
    if not user:
        raise HTTPException(status_code=400, detail="User does not exist")

    member = models.Member(
        member_user_id=m_in.member_user_id,
        house_rules=m_in.house_rules,
        dependent_description=m_in.dependent_description,
    )
    db.add(member)
    db.commit()
    db.refresh(member)
    return member


@app.get("/members/", response_model=List[schemas.MemberOut])
def list_members(db: Session = Depends(get_db)):
    return db.query(models.Member).all()


@app.post("/addresses/", response_model=schemas.AddressOut, status_code=status.HTTP_201_CREATED)
def create_address(a_in: schemas.AddressCreate, db: Session = Depends(get_db)):
    member = db.query(models.Member).filter(models.Member.member_user_id == a_in.member_user_id).first()
    if not member:
        raise HTTPException(status_code=400, detail="Member does not exist")

    address = models.Address(
        member_user_id=a_in.member_user_id,
        house_number=a_in.house_number,
        street=a_in.street,
        town=a_in.town,
    )
    db.add(address)
    db.commit()
    db.refresh(address)
    return address


@app.get("/addresses/", response_model=List[schemas.AddressOut])
def list_addresses(db: Session = Depends(get_db)):
    return db.query(models.Address).all()


@app.post("/jobs/", response_model=schemas.JobOut, status_code=status.HTTP_201_CREATED)
def create_job(job_in: schemas.JobCreate, db: Session = Depends(get_db)):
    member = db.query(models.Member).filter(models.Member.member_user_id == job_in.member_user_id).first()
    if not member:
        raise HTTPException(status_code=400, detail="Member does not exist")

    job = models.Job(
        member_user_id=job_in.member_user_id,
        required_caregiving_type=job_in.required_caregiving_type,
        other_requirements=job_in.other_requirements,
        date_posted=job_in.date_posted,
    )
    db.add(job)
    db.commit()
    db.refresh(job)
    return job


@app.get("/jobs/", response_model=List[schemas.JobOut])
def list_jobs(db: Session = Depends(get_db)):
    return db.query(models.Job).all()


@app.get("/jobs/html")
def jobs_html(request: Request, db: Session = Depends(get_db)):
    jobs = db.query(models.Job).all()
    members = db.query(models.Member).all()
    return templates.TemplateResponse(
        "jobs.html",
        {"request": request, "jobs": jobs, "members": members},
    )


@app.post("/jobs/html")
def create_job_html(
    request: Request,
    member_user_id: int = Form(...),
    required_caregiving_type: str = Form(...),
    other_requirements: str = Form(""),
    date_posted: str = Form(...),  
    db: Session = Depends(get_db),
):
    from datetime import datetime

    member = db.query(models.Member).filter(models.Member.member_user_id == member_user_id).first()
    if member:
        job = models.Job(
            member_user_id=member_user_id,
            required_caregiving_type=required_caregiving_type,
            other_requirements=other_requirements,
            date_posted=datetime.strptime(date_posted, "%Y-%m-%d").date(),
        )
        db.add(job)
        db.commit()

    jobs = db.query(models.Job).all()
    members = db.query(models.Member).all()
    return templates.TemplateResponse(
        "jobs.html",
        {"request": request, "jobs": jobs, "members": members},
    )


@app.post("/job_applications/", response_model=schemas.JobApplicationOut,
          status_code=status.HTTP_201_CREATED)
def create_job_application(ja_in: schemas.JobApplicationCreate, db: Session = Depends(get_db)):
    caregiver = db.query(models.Caregiver).filter(
        models.Caregiver.caregiver_user_id == ja_in.caregiver_user_id
    ).first()
    job = db.query(models.Job).filter(models.Job.job_id == ja_in.job_id).first()

    if not caregiver or not job:
        raise HTTPException(status_code=400, detail="Caregiver or job does not exist")

    ja = models.JobApplication(
        caregiver_user_id=ja_in.caregiver_user_id,
        job_id=ja_in.job_id,
        date_applied=ja_in.date_applied,
    )
    db.add(ja)
    db.commit()
    return ja


@app.get("/job_applications/", response_model=List[schemas.JobApplicationOut])
def list_job_applications(db: Session = Depends(get_db)):
    return db.query(models.JobApplication).all()



@app.post("/appointments/", response_model=schemas.AppointmentOut,
          status_code=status.HTTP_201_CREATED)
def create_appointment(app_in: schemas.AppointmentCreate, db: Session = Depends(get_db)):
    caregiver = db.query(models.Caregiver).filter(
        models.Caregiver.caregiver_user_id == app_in.caregiver_user_id
    ).first()
    member = db.query(models.Member).filter(
        models.Member.member_user_id == app_in.member_user_id
    ).first()

    if not caregiver or not member:
        raise HTTPException(status_code=400, detail="Caregiver or member does not exist")

    appointment = models.Appointment(
        caregiver_user_id=app_in.caregiver_user_id,
        member_user_id=app_in.member_user_id,
        appointment_date=app_in.appointment_date,
        appointment_time=app_in.appointment_time,
        work_hours=app_in.work_hours,
        status=app_in.status,
    )
    db.add(appointment)
    db.commit()
    db.refresh(appointment)
    return appointment


@app.get("/appointments/", response_model=List[schemas.AppointmentOut])
def list_appointments(db: Session = Depends(get_db)):
    return db.query(models.Appointment).all()
