--绿之✿巫女 濑笈叶
local M = c999003
local Mid = 999003
function M.initial_effect(c)
	-- fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c, aux.FilterBoolFunction(Card.IsFusionSetCard, 0xaa6), aux.FilterBoolFunction(Card.IsFusionSetCard, 0x100), true)
	-- immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(LOCATION_MZONE, 0)
	e0:SetTarget(M.etarget)
	e0:SetValue(M.efilter)
	c:RegisterEffect(e0)
	-- atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(M.atkop)
	c:RegisterEffect(e1)
	-- to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(Mid,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1, Mid+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(M.tdcon)
	e2:SetTarget(M.tdtg)
	e2:SetOperation(M.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e4)
end
M.hana_mat={
aux.FilterBoolFunction(Card.IsFusionSetCard,0xaa6),
aux.FilterBoolFunction(Card.IsFusionSetCard,0x100),
}

function M.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function M.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(M.thfilter, tp, LOCATION_GRAVE+LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, 0, 0)
end

function M.thfilter(c)
	return c:IsAbleToHand() and (c:IsSetCard(0x100) or c:GetCode() == 24094653 or c:GetCode() == 24235)
end

function M.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(M.thfilter, tp, LOCATION_GRAVE+LOCATION_DECK, 0, 1, nil) then return end
	local g = Duel.SelectMatchingCard(tp, M.thfilter, tp,  LOCATION_GRAVE+LOCATION_DECK, 0, 1, 1, nil)
	if g:GetCount() > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
	end
end

function M.etarget(e,c)
	return true
end

function M.efilter(e,re,rp)
	if re:IsActiveType(TYPE_MONSTER) and re:GetOwnerPlayer()~=e:GetHandlerPlayer() then
		local atk=e:GetHandler():GetAttack()
		local ec=re:GetOwner()
		return ec:GetAttack()<atk
	else
		return false
	end
end

function M.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:GetHandler() then return end
	if re:GetHandler():GetControler() ~= c:GetControler() and c:IsOnField() and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(100)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)

		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		c:RegisterEffect(e2)
	end
end