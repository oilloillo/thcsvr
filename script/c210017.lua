--雷符「微速的务光」
function c210017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--stg set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(210017,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,210017)
	e2:SetHintTiming(0,0x1c0)
	e2:SetTarget(c210017.sstg)
	e2:SetOperation(c210017.ssop)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetDescription(aux.Stringid(210017,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,210017)
	e3:SetHintTiming(0,0x1c0)
	e3:SetCost(c210017.scost)
	e3:SetTarget(c210017.stg)
	e3:SetOperation(c210017.sop)
	c:RegisterEffect(e3)
end
function c210017.ssfilter(c,e,tp)
	return c:IsType(TYPE_SPELL) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsFaceup()
end
function c210017.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210017.ssfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c210017.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c210017.ssop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sc=Duel.SelectMatchingCard(tp,c210017.ssfilter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	if sc and Duel.SendtoGrave(sc,REASON_EFFECT)~=0 then
		local tc=Duel.SelectMatchingCard(tp,c210017.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)		
	end
end
function c210017.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c210017.filter(c)
	return c:IsSetCard(0x710) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_PENDULUM)
end
function c210017.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210017.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c210017.sop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local m=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local n=Duel.GetMatchingGroupCount(c210017.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if m>n then m=n end
	if m>2 then m=2 end
	local g=Duel.SelectMatchingCard(tp,c210017.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,m,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)		
		tc=g:GetNext()
	end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local gc=Duel.SelectMatchingCard(tp,c210017.filter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoHand(gc,tp,REASON_EFFECT)
end
function c210017.filter2(c)
	return c:IsType(TYPE_SPELL) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsFaceup()
end