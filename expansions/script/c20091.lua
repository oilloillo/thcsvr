 
--亡舞「生者必灭之理」
function c20091.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c20091.activate)
	c:RegisterEffect(e1)
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20091,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetTarget(c20091.target)
	e2:SetOperation(c20091.operation)
	c:RegisterEffect(e2)
end
function c20091.filter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x684)
end
function c20091.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c20091.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(20091,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c20091.xfilter(c)
	return c:IsFaceup() and c:IsCode(20086)
end
function c20091.cfilter(c)
	return c:IsSetCard(0x338)
end
function c20091.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tptpttpp=eg:GetFirst():GetControler()
	if chk==0 then return tptpttpp~=tp
		and Duel.IsExistingMatchingCard(c20091.xfilter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c20091.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,1,0,0)
end
function c20091.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=eg:GetFirst()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
