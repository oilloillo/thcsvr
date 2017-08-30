 
--妖魔书-遁入幻想
function c21470103.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21470103,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c21470103.target)
	e1:SetCountLimit(1,21470103)
	e1:SetOperation(c21470103.activate)
	c:RegisterEffect(e1)
	--grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21470103,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c21470103.cost)
	e2:SetCountLimit(1,21470103)
	e2:SetTarget(c21470103.tg)
	e2:SetOperation(c21470103.op)
	c:RegisterEffect(e2)
end
function c21470103.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsSetCard(0x208)
end
function c21470103.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end --Duel.IsExistingMatchingCard(c21470103.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
end
function c21470103.activate(e,tp,eg,ep,ev,re,r,rp)
--[[	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(21470999)
	Duel.RegisterEffect(e1,tp)]]
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(21470999)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x742) and Duel.GetTurnPlayer()==tp then Duel.Draw(tp,1,REASON_EFFECT) end
end
function c21470103.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c21470103.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function c21470103.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(21470999)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end