 
--合葬「棱镜协奏曲」
function c20116.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c20116.condition)
	e1:SetTarget(c20116.target)
	e1:SetOperation(c20116.operation)
	c:RegisterEffect(e1)
end
function c20116.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x163)
end
function c20116.sfilter(c)
	return c:IsSetCard(0x1828) and c:IsSSetable()
end
function c20116.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local lc=0
	local lt=e:GetHandler():GetLocation()
	if lt==LOCATION_HAND then lc=-1 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>lc
		and Duel.IsExistingMatchingCard(c20116.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c20116.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c20116.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
		if g:GetFirst():IsType(TYPE_QUICKPLAY) then
			g:GetFirst():SetStatus(STATUS_SET_TURN,false)
		end
	end
end
