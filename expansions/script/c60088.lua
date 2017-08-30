--白焰的许愿星
function c60088.initial_effect(c)
	--announce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c60088.cost)
	e1:SetOperation(c60088.activate)
	c:RegisterEffect(e1)
end
function c60088.filter(c)
	return c:IsSetCard(0x191) and not c:IsPublic()
end
function c60088.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60088.filter,tp,0x46,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c60088.filter,tp,0x46,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabel(g:GetFirst():GetCode())
end
function c60088.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabel(e:GetLabel())
	e1:SetCondition(c60088.con)
	e1:SetOperation(c60088.operation)
	Duel.RegisterEffect(e1,tp)
end
function c60088.con(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
    return eg:FilterCount(Card.IsCode,nil,code)>0
end
function c60088.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60088)
	--Duel.BreakEffect()
	local code=e:GetLabel()
	local g=eg:Filter(Card.IsCode,nil,code)
	local lv=Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,9,10,11,12)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	Duel.Draw(tp,1,REASON_EFFECT)
end
