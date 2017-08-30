--星莲船上的探宝者✿娜兹玲
function c999603.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetDescription(aux.Stringid(999603,0))
	e1:SetCountLimit(1,9996031)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c999603.spcon)
	e1:SetOperation(c999603.spop)
	c:RegisterEffect(e1)
	--to deck top
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999603,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9996032)
	e2:SetTarget(c999603.target)
	e2:SetOperation(c999603.operation)
	c:RegisterEffect(e2)
end

function c999603.spcon(e,c)
	if c==nil then return true end
	local flag = Duel.GetFieldCard(0,LOCATION_SZONE,6) or Duel.GetFieldCard(0,LOCATION_SZONE,7) 
		or Duel.GetFieldCard(1,LOCATION_SZONE,6) or Duel.GetFieldCard(1,LOCATION_SZONE,7)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and flag
end

function c999603.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	e1:SetDescription(aux.Stringid(999603,2))
	e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e:GetHandler():RegisterEffect(e1)
end

function c999603.filter(c)
	return c:IsType(TYPE_PENDULUM) or c:IsSetCard(0x252)
end

function c999603.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(c999603.filter,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=5
	end
end

function c999603.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c999603.filter,tp,LOCATION_DECK,0,nil)
	if not (g:GetClassCount(Card.GetCode)>=5) then return end

	local sg1=Group.CreateGroup()

	for i=1,5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tempg=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,tempg:GetFirst():GetCode())
		sg1:Merge(tempg)
		tempg:DeleteGroup()
	end
	
	Duel.ShuffleDeck(tp)

	while sg1:GetCount()>0 do
		local tg1=sg1:RandomSelect(tp,1)
		local tc=tg1:GetFirst()
		Duel.MoveSequence(tc,0)
		sg1:RemoveCard(tc)
	end
end
