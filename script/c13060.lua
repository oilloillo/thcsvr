--暗能之草莓十字
function c13060.initial_effect(c)
	--deep
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c13060.condition)
	e1:SetTarget(c13060.target)
	e1:SetOperation(c13060.operation)
	c:RegisterEffect(e1)
	--dark
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,13060)
	e2:SetCost(c13060.cost)
	e2:SetTarget(c13060.thtg)
	e2:SetOperation(c13060.thop)
	c:RegisterEffect(e2)
end
function c13060.condition(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())==0
	local g2=Duel.GetMatchingGroupCount(aux.TRUE,tp,0xe,0,e:GetHandler())==0
	local g3=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,0xe,e:GetHandler())==0
	--local g5=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_GRAVE,e:GetHandler())==0
	return g1 or g2 or g3
end
function c13060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,PLAYER_ALL,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,5)
end
function c13060.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	if g:GetCount()>0 then Duel.SendtoDeck(g,nil,2,REASON_EFFECT) end
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
	Duel.BreakEffect()
	Duel.Draw(tp,5,REASON_EFFECT)
	Duel.Draw(1-tp,5,REASON_EFFECT)
end
function c13060.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local tc=tg:GetFirst()
	if chk==0 then return tc end
	while tc do
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetOperation(c13060.reop)
		Duel.RegisterEffect(e1,tp)
		tc=tg:GetNext()
	end
end
function c13060.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c13060.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c13060.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
