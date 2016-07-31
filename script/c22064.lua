 
--妖精女仆B
function c22064.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22064.spcon)
	e1:SetOperation(c22064.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22064,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c22064.cost)
	e2:SetTarget(c22064.target)
	e2:SetOperation(c22064.operation)
	c:RegisterEffect(e2)
	if not c22064.global_check then
		c22064.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c22064.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c22064.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local sump=tc:GetSummonPlayer()
		if not tc:IsPreviousLocation(LOCATION_EXTRA) and Duel.GetFlagEffect(sump,22064)==0 then
			Duel.RegisterFlagEffect(sump,22064,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function c22064.spfilter(c)
	return c:IsFaceup() and (c:GetOriginalCode()==(22100) or c:GetOriginalCode()==(22117))
end
function c22064.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c22064.spfilter,c:GetControler(),LOCATION_SZONE,0,1,nil) and
			Duel.GetFlagEffect(c:GetControler(),22064)==0
end
function c22064.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local fid=e:GetHandler():GetFieldID()
	e:SetLabel(fid)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabel(fid)
	e1:SetTarget(c22064.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c22064.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return e:GetLabel()~=se:GetLabel() and not c:IsLocation(LOCATION_EXTRA)
end
function c22064.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c22064.filter(c)
	return c:GetOriginalCode()==(22117) and c:IsAbleToHand()
end
function c22064.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22064.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22064.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c22064.filter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
