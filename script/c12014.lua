 
--战车娘里香
function c12014.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetDescription(aux.Stringid(12014,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c12014.eqtg)
	e1:SetOperation(c12014.eqop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_EQUIP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c12014.operation)
	c:RegisterEffect(e2)
end
function c12014.filter(c)
	return c:IsSetCard(0x263) and c:IsType(TYPE_UNION)
end
function c12014.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():GetUnionCount()==0
		and Duel.IsExistingMatchingCard(c12014.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c12014.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c12014.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.Equip(tp,tc,c,true) then
		tc:SetStatus(STATUS_UNION,true)
	end
end
function c12014.afilter(c)
	return c:IsType(TYPE_UNION)
end
function c12014.operation(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(c12014.afilter,1,nil) then return end
	local att=eg:SearchCard(c12014.afilter)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(att:GetTextAttack())
	att:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENCE)
	e2:SetValue(att:GetTextDefence())
	att:RegisterEffect(e2)
end
