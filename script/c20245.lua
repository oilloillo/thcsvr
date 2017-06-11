--幽灵与人类的混血✿魂魄妖梦
function c20245.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fus.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x713),c20245.mfilter,true)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20245,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c20245.cost)
	e2:SetTarget(c20245.target)
	e2:SetOperation(c20245.activate)
	c:RegisterEffect(e2)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c20245.thcon)
	e5:SetTarget(c20245.thtg)
	e5:SetOperation(c20245.thop)
	c:RegisterEffect(e5)
end
function c20245.mfilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsRace(RACE_ZOMBIE)
end
function c20245.costfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsLevelAbove(3) and c:IsAbleToRemoveAsCost()
end
function c20245.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20245.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c20245.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c20245.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and not c:IsStatus(STATUS_CHAINING) and c:IsAttackPos() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function c20245.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end
function c20245.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c20245.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if chk==0 then return lpz==nil and rpz==nil end
end
function c20245.thop(e,tp,eg,ep,ev,re,r,rp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if lpz or rpz then return end
	local lp=Duel.CreateToken(tp,20252)
	local rp=Duel.CreateToken(tp,20253)
	Duel.MoveToField(lp, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
	Duel.MoveToField(rp, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
end
