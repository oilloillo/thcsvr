--妖精☆大暴走
function c999501.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetCountLimit(1,999501+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c999501.cost)
	e1:SetTarget(c999501.target)
	e1:SetOperation(c999501.operation)
	c:RegisterEffect(e1)
	if not c999501.global_check then
		c999501.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c999501.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c999501.clear)
		Duel.RegisterEffect(ge2,0)
	end
end

function c999501.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetReasonEffect():IsHasType(EFFECT_TYPE_ACTIONS) and not tc:IsSetCard(0x999) then
			c999501[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end

function c999501.clear(e,tp,eg,ep,ev,re,r,rp)
	c999501[0]=true
	c999501[1]=true
end

function c999501.costfilter(c)
	return (c:IsCode(25020) or c:IsCode(25021) or c:IsCode(25022)) and c:IsAbleToRemoveAsCost()
end

function c999501.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c999501.costfilter, tp, LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE, 0, nil)
	if chk==0 then return g:GetCount()>=2 and c999501[tp] end
	local rg=g:Select(tp,2,2,nil)
	if e:GetLabelObject() then e:GetLabelObject():DeleteGroup() end
	e:SetLabelObject(rg)
	rg:KeepAlive()
	Duel.Remove(rg,POS_FACEUP,REASON_COST)

	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c999501.splimit)
	Duel.RegisterEffect(e1,tp)
end

function c999501.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se:IsHasType(EFFECT_TYPE_ACTIONS) and not c:IsSetCard(0x999)
end

function c999501.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if chk==0 then return lpz==nil and rpz==nil end
end

function c999501.operation(e,tp,eg,ep,ev,re,r,rp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if lpz or rpz then return end

	local rg=e:GetLabelObject()
	local fc=rg:GetFirst()
	while fc do
		local code=fc:GetCode() - 25020 + 999502
		local token=Duel.CreateToken(tp,code)
		Duel.MoveToField(token, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
		fc=rg:GetNext()
	end
end