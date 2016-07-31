 
--春之到来
function c20056.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c20056.cost)
	e1:SetTarget(c20056.target)
	e1:SetOperation(c20056.activate)
	c:RegisterEffect(e1)
	if not c20056.global_check then
		c20056.global_check=true
		c20056[0]=true
		c20056[1]=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c20056.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c20056.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c20056.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:GetSummonType()~=SUMMON_TYPE_XYZ then
		c20056[tc:GetControler()]=false
	end
end
function c20056.clear(e,tp,eg,ep,ev,re,r,rp)
	c20056[0]=true
	c20056[1]=true
end
function c20056.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c20056[tp] end-- and Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c20056.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTargetRange(1,0)
	--Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	--Duel.RegisterEffect(e3,tp)
end
function c20056.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return sumtype~=SUMMON_TYPE_XYZ and e:GetLabelObject()~=se
end
function c20056.filter(c,e,tp)
	return c:IsCode(20013) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and Duel.IsExistingMatchingCard(c20056.filter,tp,LOCATION_EXTRA,0,3,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_EXTRA)
end
function c20056.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20056.filter,tp,LOCATION_EXTRA,0,3,3,nil,e,tp)
	if g:GetCount()>2 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local tc=g:GetFirst()
	while tc do
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetOperation(c20056.desop)
		tc:RegisterEffect(e2)
	tc=g:GetNext()
	end
end
function c20056.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),nil,REASON_EFFECT)
end
