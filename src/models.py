from datetime import datetime
from enum import Enum
from typing import List, Optional

from fastapi import Form
from pydantic import BaseModel, BeforeValidator, EmailStr, Field
from typing_extensions import Annotated

PyObjectId = Annotated[str, BeforeValidator(str)]


class TimeStampMixin(BaseModel):
    created_at: datetime = Field(default_factory=datetime.now)
    updated_at: datetime = Field(default_factory=datetime.now)

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.updated_at = datetime.now()


class MongoBaseModel(TimeStampMixin):
    id: Optional[PyObjectId] = Field(alias="_id", default=None)

    @property
    def mongo_model_dump(self):
        return self.model_dump(exclude={"id"})  


class AccessToken(BaseModel):
    access_token: str
    exp: datetime


class TokenData(BaseModel):
    user_id: str
    email: EmailStr
    exp: datetime
    tacs: List[str]


class Status(str, Enum):
    pending = "pending"
    confirmed = "confirmed"
    denied = "denied"
    unknown = "unknown"


class SocialType(str, Enum):
    facebook = "facebook"
    google = "google"
    apple = "apple"


class MediaCategory(str, Enum):
    photo = "photo"
    video = "video"
    gif = "gif"


class User(MongoBaseModel):
    social_id: Optional[str] = None
    name: str
    surname: Optional[str] = None
    email: EmailStr
    password: Optional[str] = None
    cellphone: Optional[int] = None
    social_type: Optional[SocialType] = None
    verification_code: Optional[str] = None
    terms_and_conditions: List[str] = []
    status: Status = "unknown"
    liked_vehicles: list[str] = []
    disliked_vehicles: list[str] = []

    @classmethod
    def new_user(
            cls,
            name: str = Form(...),
            surname: str = Form(default=None),
            email: EmailStr = Form(...),
            password: str = Form(...),
            cellphone: int = Form(...)
    ):
        return cls(
            name=name,
            surname=surname,
            email=email,
            password=password,
            cellphone=cellphone
        )


class TermAndConditions(MongoBaseModel):
    title: str
    slug: str
    body: str


class VehicleMediaRegister(BaseModel):
    title: str
    category: MediaCategory

    @classmethod
    def as_form(
            cls,
            title: str = Form(...),
            category: MediaCategory = Form(...),
    ):
        return cls(
            title=title,
            category=category,
        )


class VehicleMedia(VehicleMediaRegister):
    file: str
    url: Optional[str] = None


class Vehicle(MongoBaseModel):
    owner_id: PyObjectId = Field(default=None)
    family: List[str]
    body_type: str
    makes: str
    model: str
    color: str
    options: List[str] = []
    mileage: int
    price: float
    media: List[VehicleMedia] = []
    vin_number: Optional[str]

    @classmethod
    def as_form(
            cls,
            family: List[str] = Form(...),
            body_type: str = Form(...),
            makes: str = Form(...),
            model: str = Form(...),
            color: str = Form(...),
            options: List[str] = Form(default=None),
            mileage: int = Form(...),
            price: float = Form(...),
            vin_number: str = Form(...)
    ):
        return cls(
            family=family,
            body_type=body_type,
            makes=makes,
            model=model,
            color=color,
            options=options,
            mileage=mileage,
            price=price,
            vin_number=vin_number
        )


class VehicleRegister(Vehicle):
    owner_id: Optional[str] = None


class VehicleSearchParameters(MongoBaseModel):
    family: list[str] = []
    body_type: Optional[str] = None
    makes: Optional[str] = None
    model: Optional[str] = None
    color: Optional[str] = None
    options: list[str] = []
    mileage: Optional[int] = None
    price: Optional[float] = None
    only_show_liked: bool = False
    only_show_disliked: bool = False

    @classmethod
    def as_form(
            cls,
            family: List[str] = Form(default=[]),
            body_type: str = Form(default=None),
            makes: str = Form(default=None),
            model: str = Form(default=None),
            color: str = Form(default=None),
            options: List[str] = Form(default=[]),
            mileage: int = Form(default=None),
            price: float = Form(default=None),
    ):
        return cls(
            family=family,
            body_type=body_type,
            makes=makes,
            model=model,
            color=color,
            options=options,
            mileage=mileage,
            price=price,
        )


class VehiclePricing(BaseModel):
    price: float
    auction_price: float
    trade_in_value: float
    dealer_price: float
    days_to_sell: int
    chances_of_selling: int


class Order(MongoBaseModel):
    vehicle_id: PyObjectId
    buyer_id: PyObjectId
    seller_id: PyObjectId
    current_status: Optional[str] = "pending"
    old_status: Optional[str] = None

    @classmethod
    def as_form(
            cls,
            vehicle_id: PyObjectId = Form(...),
            buyer_id: PyObjectId = Form(...),
            seller_id: PyObjectId = Form(...),
    ):
        return cls(
            vehicle_id=vehicle_id,
            buyer_id=buyer_id,
            seller_id=seller_id
        )


class Signer(BaseModel):
    name: str
    email: EmailStr
    anchor_string: str


class DocusignDocument(MongoBaseModel):
    signers: list[Signer]
    subject: str
    doc_base64: str
    envelope_id: Optional[int] = None


class Chat(TimeStampMixin):
    id: Optional[PyObjectId] = Field(alias="_id", default=None)
    vehicle_id: PyObjectId
    buyer_id: PyObjectId
    seller_id: PyObjectId
    sender_id: PyObjectId
    message: str

    @classmethod
    def as_form(
            cls,
            vehicle_id: PyObjectId = Form(...),
            buyer_id: PyObjectId = Form(...),
            seller_id: PyObjectId = Form(...),
            sender_id: PyObjectId = Form(...),
            message: str = Form(...),
    ):
        return cls(
            vehicle_id=vehicle_id,
            buyer_id=buyer_id,
            seller_id=seller_id,
            sender_id=sender_id,
            message=message
        )
