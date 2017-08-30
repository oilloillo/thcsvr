--『杀意的百合』
function c31063.initial_effect(c)
	--damage avoid
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c31063.activate)
	c:RegisterEffect(e1)
end
function c31063.filter(c)
	return c:IsSetCard(0x276) and c:IsFaceup()
end
function c31063.activate(e,tp,eg,ep,ev,re,r,rp)
	local j=1
	if Duel.IsExistingMatchingCard(c31063.filter,tp,LOCATION_MZONE,0,1,nil) then j=3 end
	local num=0
	for i=1,j do
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(31063,0))
		local temp=Duel.AnnounceNumber(tp,1,2,3,4,5)
		num = num * 10 + temp
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabel(num)
	e2:SetOperation(c31063.op)
	Duel.RegisterEffect(e2,tp)
end
function c31063.op(e,tp,eg,ep,ev,re,r,rp)
	local num=e:GetLabel()
	while num>0 do
		local temp=num%10
		local seq=5-temp
		local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,seq)
		if tc and tc:IsDestructable() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
		num = (num - temp) / 10
	end
end
