 
--JK东风谷早苗
function c23030.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.XyzFilterFunction(c,6),2)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23030,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c23030.cost)
	e1:SetTarget(c23030.target)
	e1:SetOperation(c23030.activate)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c23030.con1)
	e2:SetOperation(c23030.sumsuc)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c23030.drcon)
	e3:SetTarget(c23030.drtg)
	e3:SetOperation(c23030.drop)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(23030,1))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c23030.con2)
	e4:SetCost(c23030.cost)
	e4:SetTarget(c23030.tdtg)
	e4:SetOperation(c23030.tdop)
	c:RegisterEffect(e4)
	--recover
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(23030,2))
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCondition(c23030.con2)
	e5:SetTarget(c23030.rctg)
	e5:SetOperation(c23030.rcop)
	c:RegisterEffect(e5)
end
function c23030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c23030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,1-tp,LOCATION_ONFIELD)
end
function c23030.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
	local dg=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,1-tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.HintSelection(dg)
	Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
end
function c23030.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c23030.filter1,1,nil)
end
function c23030.chainlm(e,rp,tp)
	return tp==rp
end
function c23030.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c23030.chainlm)
end
function c23030.filter1(c)
	return c:IsSetCard(0x208) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c23030.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetOverlayGroup():IsExists(c23030.filter1,1,nil)
end
function c23030.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c23030.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c23030.filter2(c)
	return c:IsSetCard(0x208) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c23030.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(c23030.filter2,1,nil)
end
function c23030.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
end
function c23030.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
	local dg=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,1-tp,LOCATION_HAND,0,1,1,nil)
	Duel.HintSelection(dg)
	Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
end
function c23030.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c23030.rcop(e,tp,eg,ep,ev,re,r,rp)
	local rt=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)*400
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rt,REASON_EFFECT)
end
