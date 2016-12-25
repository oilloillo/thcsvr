--学会的异端✿冈崎梦美
function c13072.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13072,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e2:SetTarget(c13072.sptg)
	e2:SetOperation(c13072.spop)
	c:RegisterEffect(e2)
	if c13072.counter==nil then
		c13072.counter=true
		c13072[0]=0
		c13072[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c13072.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_TO_GRAVE)
		e3:SetOperation(c13072.addcount)
		Duel.RegisterEffect(e3,0)
	end
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13072,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c13072.target)
	e3:SetOperation(c13072.operation)
	c:RegisterEffect(e3)
	--only 1 can exists
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e4:SetCondition(c13072.excon)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	e6:SetCode(EFFECT_CANNOT_SUMMON)
	e6:SetTarget(c13072.sumlimit)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e8)
	--selfdes
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_SELF_DESTROY)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(LOCATION_MZONE,0)
	e9:SetTarget(c13072.destarget)
	c:RegisterEffect(e9)
end
function c13072.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c13072[0]=0
	c13072[1]=0
end
function c13072.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if bit.band(tc:GetReason(),0x1)~=0x1 then return end
		if tc:GetPreviousLocation()==LOCATION_SZONE then
			local p=tc:GetReasonPlayer()
			if p==0 or p==1 then c13072[p]=c13072[p]+1 end
		elseif bit.band(tc:GetType(),TYPE_SPELL)==TYPE_SPELL or bit.band(tc:GetType(),TYPE_TRAP)==TYPE_TRAP then
			local p=tc:GetReasonPlayer()
			if p==0 or p==1 then c13072[p]=c13072[p]+1 end
		end
		tc=eg:GetNext()
	end
end
function c13072.filter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsReason(REASON_DESTROY) and c:GetReasonPlayer()==tp and c:GetTurnID()==Duel.GetTurnCount()
end
function c13072.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) 
		and c13072[tp]>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c13072.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c13072.desfilter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c13072.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c13072.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13072.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if g:GetCount()==0 then
		g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	end
	local sg=g:RandomSelect(tp,1)
	if sg:GetCount()>0 and Duel.Destroy(sg,REASON_EFFECT)>0 then
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e5:SetTargetRange(LOCATION_SZONE,0)
		e5:SetReset(RESET_PHASE+PHASE_END)
		e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x13e))
		Duel.RegisterEffect(e5,tp)
	end
end
function c13072.sumlimit(e,c)
	return c:IsSetCard(0x13d)
end
function c13072.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x13d)
end
function c13072.excon(e)
	return Duel.IsExistingMatchingCard(c13072.exfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c13072.destarget(e,c)
	return c:IsSetCard(0x13d) and c:GetFieldID()>e:GetHandler():GetFieldID()
end
