--最强人类✿冈崎梦美
function c13078.initial_effect(c)
	c:SetUniqueOnField(1,0,1302170,LOCATION_MZONE)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13078,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1,13078)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e2:SetTarget(c13078.sptg)
	e2:SetOperation(c13078.spop)
	c:RegisterEffect(e2)
	if c13078.counter==nil then
		c13078.counter=true
		c13078[0]=0
		c13078[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c13078.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_TO_GRAVE)
		e3:SetOperation(c13078.addcount)
		Duel.RegisterEffect(e3,0)
	end
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetDescription(aux.Stringid(13078,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,13079)
	e3:SetTarget(c13078.target)
	e3:SetOperation(c13078.operation)
	c:RegisterEffect(e3)
	--only 1 can exists
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e4:SetCondition(c13078.excon)
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
	e6:SetTarget(c13078.sumlimit)
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
	e9:SetTarget(c13078.destarget)
	c:RegisterEffect(e9)
end
function c13078.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c13078[0]=0
	c13078[1]=0
end
function c13078.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if bit.band(tc:GetReason(),0x1)~=0x1 then return end
		if tc:GetPreviousLocation()==LOCATION_SZONE then
			local p=tc:GetReasonPlayer()
			if p==0 or p==1 then c13078[p]=c13078[p]+1 end
		elseif bit.band(tc:GetType(),TYPE_SPELL)==TYPE_SPELL or bit.band(tc:GetType(),TYPE_TRAP)==TYPE_TRAP then
			local p=tc:GetReasonPlayer()
			if p==0 or p==1 then c13078[p]=c13078[p]+1 end
		end
		tc=eg:GetNext()
	end
end
function c13078.filter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsReason(REASON_DESTROY) and c:GetReasonPlayer()==tp and c:GetTurnID()==Duel.GetTurnCount()
end
function c13078.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) 
		and c13078[tp]>4 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c13078.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c13078.afilter(c,atk)
	return c:GetAttack()<=atk and c:IsAbleToRemove()
end
function c13078.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	local atk=e:GetHandler():GetAttack()*3.14
	local sg=Duel.GetMatchingGroup(c13078.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,atk)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,sg:GetCount()*1024)
	Duel.SetChainLimit(aux.FALSE)
end
function c13078.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c13078.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),atk)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
	if ct>0 then
		--Duel.BreakEffect()
		Duel.Damage(1-tp,ct*1024,REASON_EFFECT)
	end
end
function c13078.sumlimit(e,c)
	return c:IsSetCard(0x13d)
end
function c13078.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x13d)
end
function c13078.excon(e)
	return Duel.IsExistingMatchingCard(c13078.exfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c13078.destarget(e,c)
	return c:IsSetCard(0x13d) and c:GetFieldID()>e:GetHandler():GetFieldID()
end
