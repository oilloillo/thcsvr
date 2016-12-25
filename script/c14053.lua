--梦幻馆 湖上的吸血鬼✿胡桃
function c14053.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c14053.condition)
	e1:SetOperation(c14053.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14053,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c14053.tecon)
	e2:SetTarget(c14053.tetg)
	e2:SetOperation(c14053.teop)
	c:RegisterEffect(e2)
end
function c14053.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp 
end
function c14053.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev/2,REASON_EFFECT)
end
function c14053.cfilter(c)
	return c:IsCode(14035) and c:IsFaceup()
end
function c14053.tecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c14053.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
function c14053.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c14053.teop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetOperation(c14053.thop)
	c:RegisterEffect(e1)
end
function c14053.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,c)
end
