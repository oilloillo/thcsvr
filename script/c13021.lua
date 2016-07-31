 
--梦幻传说 冈崎梦美
function c13021.initial_effect(c)
	c:SetUniqueOnField(1,0,13021)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13021,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e2:SetTarget(c13021.sptg)
	e2:SetOperation(c13021.spop)
	c:RegisterEffect(e2)
	if c13021.counter==nil then
		c13021.counter=true
		c13021[0]=0
		c13021[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c13021.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_TO_GRAVE)
		--e3:SetCode(EVENT_DESTROYED)
		e3:SetOperation(c13021.addcount)
		Duel.RegisterEffect(e3,0)
	end
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c13021.dfgdfg)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(13021,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c13021.target)
	e5:SetOperation(c13021.operation)
	c:RegisterEffect(e5)
	--Cost
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_CHAINING)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(c13021.condition)
	e8:SetOperation(c13021.cost)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(1,1)
	e9:SetCondition(c13021.accon)
	e9:SetValue(c13021.actlimit)
	c:RegisterEffect(e9)
end
function c13021.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c13021[0]=0
	c13021[1]=0
end
function c13021.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if bit.band(tc:GetReason(),0x1)~=0x1 then return end
		if tc:GetPreviousLocation()==LOCATION_SZONE then
			local p=tc:GetReasonPlayer()
			if p==0 or p==1 then c13021[p]=c13021[p]+1 end
		elseif bit.band(tc:GetType(),TYPE_SPELL)==TYPE_SPELL or bit.band(tc:GetType(),TYPE_TRAP)==TYPE_TRAP then
			local p=tc:GetReasonPlayer()
			if p==0 or p==1 then c13021[p]=c13021[p]+1 end
		end
		tc=eg:GetNext()
	end
end
function c13021.filter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsReason(REASON_DESTROY) and c:GetReasonPlayer()==tp and c:GetTurnID()==Duel.GetTurnCount()
end
function c13021.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) 
		and c13021[tp]>2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c13021.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c13021.dfgdfg(e,re)
	return not re:GetHandler():IsType(TYPE_MONSTER)
end
function c13021.desfilter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c13021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c13021.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13021.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c13021.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c13021.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c13021.condition(e,tp,eg,ep,ev,re,r,rp)
	return not re:IsActiveType(TYPE_MONSTER) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c13021.cost(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(1-tp,1000)
end
function c13021.accon(e)
	return Duel.GetLP(1-e:GetHandler():GetControler())<=1000
end
function c13021.actlimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
