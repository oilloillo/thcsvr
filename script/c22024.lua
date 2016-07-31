 
--红魔-蕾米莉亚·斯卡雷特
function c22024.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x208),1)
	c:EnableReviveLimit()
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(22024,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c22024.condition)
	e1:SetCost(c22024.cost)
	e1:SetTarget(c22024.target)
	e1:SetOperation(c22024.operation)
	c:RegisterEffect(e1)
	--Race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_RACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(RACE_FIEND)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22024,1))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c22024.tdcon)
	e4:SetTarget(c22024.tdtg)
	e4:SetOperation(c22024.tdop)
	c:RegisterEffect(e4)
end
function c22024.costfilter(c)
	return (c:IsSetCard(0x813) or c:GetOriginalCode()==(22100) or c:GetOriginalCode()==(22117)) and c:IsAbleToRemoveAsCost()
end
function c22024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22024.costfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c22024.costfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c22024.condition(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	return e:GetHandler():IsFaceup()
		and Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
end
function c22024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local seq=e:GetHandler():GetSequence()
	e:SetLabel(seq)
	local g=Group.CreateGroup()
	g:AddCard(Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c22024.operation(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetLabel()
	local g=Group.CreateGroup()
	local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4-seq)
	if tc then g:AddCard(tc) end
	Duel.Destroy(g,REASON_EFFECT)
	Duel.BreakEffect()
	local tcc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4-seq)
	if tcc then
	Duel.Destroy(tcc,REASON_EFFECT)
	else 
	Duel.Damage(1-tp,1200,REASON_EFFECT)
	end
end
function c22024.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c22024.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,1,0)
end
function c22024.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,1-tp,2,REASON_EFFECT)
	end
end
