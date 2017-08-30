 
--幽梦～Inanimate Dream
function c14036.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetOperation(c14036.activate)
	c:RegisterEffect(e1)
	if c14036.counter==nil then
		c14036.counter=true
		c14036[0]=0
		c14036[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c14036.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_SUMMON_SUCCESS)
		e3:SetOperation(c14036.addcount)
		Duel.RegisterEffect(e3,0)
	end
end
function c14036.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c14036[0]=0
	c14036[1]=0
end
function c14036.addcount(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	while c~=nil do
		local p=c:GetControler()
		if c:IsSetCard(0x208) and bit.band(c:GetSummonType(),SUMMON_TYPE_ADVANCE)==SUMMON_TYPE_ADVANCE then c14036[p]=c14036[p]+1 end
		c=eg:GetNext()
	end
end
function c14036.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c14036.droperation)
	Duel.RegisterEffect(e1,tp)
end
function c14036.droperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,14036)
	Duel.Draw(tp,c14036[tp]*2,REASON_EFFECT)
end
