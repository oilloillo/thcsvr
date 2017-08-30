 
--しろかみ 芙萝·谢库丽特
function c60033.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c60033.spcon)
	e1:SetOperation(c60033.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
function c60033.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x191)
end
function c60033.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,60033)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c60033.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c60033.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RegisterFlagEffect(tp,60033,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
