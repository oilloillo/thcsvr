 
--蓬莱山辉夜
function c21021.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x256),1)
	c:EnableReviveLimit()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21021,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCountLimit(3)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_RECOVER)
	e1:SetCondition(c21021.cd)
	e1:SetCost(c21021.cost)
	e1:SetOperation(c21021.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_DAMAGE)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DRAW)
	e3:SetOperation(c21021.recop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c21021.spr)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(21021,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetCondition(c21021.spcon)
	e5:SetTarget(c21021.sptg)
	e5:SetOperation(c21021.spop)
	c:RegisterEffect(e5)
end
function c21021.cd(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return tp==ep
end
function c21021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,21021)<=2 end
	Duel.RegisterFlagEffect(tp,21021,RESET_PHASE+PHASE_END,0,1)
end
function c21021.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
end
function c21021.recop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return end
	Duel.Recover(tp,1000,REASON_EFFECT)
end
function c21021.spr(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(r,0x41)~=0x41 or c:IsPreviousLocation(LOCATION_SZONE) then return end
	c:RegisterFlagEffect(21021,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,0,1)
end
function c21021.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetTurnID()~=Duel.GetTurnCount() and c:GetFlagEffect(21021)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21021.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21021.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	    Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
	end
end
