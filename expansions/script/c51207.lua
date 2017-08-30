--夏日时光
function c51207.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(51207,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c51207.condition)
	e1:SetTarget(c51207.destg)
	e1:SetOperation(c51207.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51207,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c51207.destg2)
	e2:SetCondition(c51207.condition2)
	e2:SetOperation(c51207.activate2)
	c:RegisterEffect(e2)
end
function c51207.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if not tc1 or not tc2 or not tc1:IsSetCard(0x511) or not tc2:IsSetCard(0x511) then return false end
	local scl1=tc1:GetLeftScale()
	local scl2=tc2:GetRightScale()
	if scl1>scl2 then scl1,scl2=scl2,scl1 end
	return scl1==1 and scl2==7
end
function c51207.condition2(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if not tc1 or not tc2 or not tc1:IsSetCard(0x511) or not tc2:IsSetCard(0x511) then return false end
	local scl1=tc1:GetLeftScale()
	local scl2=tc2:GetRightScale()
	if scl1>scl2 then scl1,scl2=scl2,scl1 end
	return scl1==2 and scl2==6
end
function c51207.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c51207.dfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c51207.dfilter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c51207.dfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,c51207.dfilter,tp,0,LOCATION_SZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
end
function c51207.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
	end
end
function c51207.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c51207.dfilter2,tp,0,LOCATION_MZONE,1,nil)
	and Duel.IsExistingTarget(c51207.dfilter2,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c51207.dfilter2,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectTarget(tp,c51207.dfilter2,tp,0,LOCATION_SZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,2,0,0)
end
function c51207.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end