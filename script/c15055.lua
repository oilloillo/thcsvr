 
--魔界~Devil's World
function c15055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e2:SetTarget(c15055.lvtg)
	e2:SetValue(-1)
	c:RegisterEffect(e2)
	--Atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c15055.tg)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetValue(200)
	c:RegisterEffect(e3)
	--Def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c15055.tg)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetValue(200)
	c:RegisterEffect(e4)
	--sol
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(15055,0))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_TO_GRAVE)
	--e5:SetCondition(c15055.condition)
	e5:SetTarget(c15055.target)
	e5:SetOperation(c15055.operation)
	c:RegisterEffect(e5)
end
function c15055.lvtg(e,c)
	return c:IsSetCard(0x150)
end
function c15055.tg(e,c)
	return c:IsRace(RACE_FIEND) or c:IsRace(RACE_SPELLCASTER)
end
function c15055.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c15055.filter(c)
	return c:IsCode(15019) and c:IsAbleToHand()
end
function c15055.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c15055.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c15055.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c15055.filter,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
