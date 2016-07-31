 
--亡乡「亡我乡」
function c20090.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c20090.activate)
	c:RegisterEffect(e1)
	--to deck top
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20090,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c20090.target)
	e2:SetOperation(c20090.operation)
	c:RegisterEffect(e2)
	--adc
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20090,1))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c20090.addct)
	e3:SetOperation(c20090.addc)
	c:RegisterEffect(e3)
end
function c20090.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c:IsType(TYPE_SPIRIT) and c:IsSetCard(0x208)
end
function c20090.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c20090.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(20090,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c20090.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_SPIRIT) end
end
function c20090.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(20090,2))
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,1,1,nil,TYPE_SPIRIT)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end
function c20090.xfilter(c)
	return c:IsFaceup()
end
function c20090.addct(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c20090.xfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20090.xfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.SelectTarget(tp,c20090.xfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
end
function c20090.addc(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x28b,2)
	end
end
