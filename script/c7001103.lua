--蓬莱的二人
function c7001103.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCondition(c7001103.hocon)
	e1:SetTarget(c7001103.pctg)
	e1:SetOperation(c7001103.pcop)
	c:RegisterEffect(e1)
end
function c7001103.pcfilter1(c)
	return  c:IsType(TYPE_PENDULUM) and c:IsCode(7001001) and not c:IsForbidden()
end
function c7001103.pcfilter2(c)
	return  c:IsType(TYPE_PENDULUM) and c:IsCode(7001000) and not c:IsForbidden()
end
function c7001103.pctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and (c7001103.pcfilter1(chkc) or c7001103.pcfilter2(chkc)) end
	local b1=Duel.IsExistingTarget(c7001103.pcfilter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_SZONE,0,1,nil,7001000)
	local b2=Duel.IsExistingMatchingCard(c7001103.pcfilter2,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_SZONE,0,1,nil,7001001)
	if chk==0 then
		if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
		return b1 or b2
	end
	local op=0
	--if b1 and b2 then return end
	if b1 then op=1
	else op=2 end
	e:SetLabel(op)
	if op==1 or op==2 then
		e:SetProperty(0)
	end
end
function c7001103.pcop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,7001001)
	local g2=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,7001000)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	if e:GetLabel()==1 and g1:GetCount()>0 then
		Duel.MoveToField(g1:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	else
		Duel.MoveToField(g2:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end