 --七曜-日木符「光合作用」
function c888184.initial_effect(c)
	--d&d
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888184,1))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c888184.target)
	e4:SetOperation(c888184.operation)
	c:RegisterEffect(e4)
end
function c888184.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x177) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)
		and Duel.IsExistingMatchingCard(c888184.cfilter,c:GetControler(),0x13,0,1,nil,c:GetCode())
end
function c888184.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnfield() and c888184.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>=0 and
		Duel.IsExistingTarget(c888184.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c888184.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c888184.cfilter(c,code)
	return c:GetCode()==code
end
function c888184.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)+1
	if ft>0 and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		local g=Duel.GetMatchingGroup(c888184.cfilter,tp,0x13,0,nil,tc:GetCode())
		if g:GetCount()<=ft then c888184.st(g,tp)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local fg=g:Select(tp,ft,ft,nil)
			c888184.st(fg,tp)
		end
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end
function c888184.st(g,tp)
	local sc=g:GetFirst()
	while sc do
		Duel.SSet(tp,sc)
		Duel.ConfirmCards(1-tp,sc)
		sc=g:GetNext()
	end
end
