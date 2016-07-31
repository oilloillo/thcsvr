 
--七曜-水符「湖葬」
function c888152.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888152,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1)
	e4:SetCondition(c888152.drcon)
	e4:SetCost(c888152.drcost)
	e4:SetOperation(c888152.drop)
	c:RegisterEffect(e4)
	local e3=e4:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c888152.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c888152.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.PayLPCost(tp,800) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c888152.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	if tc:IsSetCard(0x177) and tc:IsType(TYPE_SPELL) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,2,nil)
		Duel.SendtoGrave(dg,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
end
