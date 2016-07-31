 
--秘封「鸟船遗迹」
function c28025.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c28025.condition)
	e2:SetTarget(c28025.filter)
	e2:SetValue(-1300)
	c:RegisterEffect(e2)
	--Def down
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e3)
	--cost
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(c28025.mtop)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(28025,0))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCost(c28025.cost)
	e5:SetTarget(c28025.target)
	e5:SetOperation(c28025.operation)
	c:RegisterEffect(e5)
end
function c28025.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL
end
function c28025.filter(e,c)
	return not c:IsSetCard(0x211)
end
function c28025.cffilter(c)
	return c:IsSetCard(0x211) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c28025.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	if Duel.IsExistingMatchingCard(c28025.cffilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28025,1)) then
	local g=Duel.SelectMatchingCard(tp,c28025.cffilter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
function c28025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,28025)<=1 end
	Duel.RegisterFlagEffect(tp,28025,RESET_PHASE+PHASE_END,0,1)
end
function c28025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c28025.rmfilter(c)
	return c:IsSetCard(0x211) and c:IsAbleToRemove()
end
function c28025.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c28025.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
