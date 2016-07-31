 
--红蝙蝠「吸血鬼之夜」
function c22124.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c22124.cost)
	e1:SetTarget(c22124.target)
	e1:SetOperation(c22124.activate)
	c:RegisterEffect(e1)
	if not c22124.global_check then
		c22124.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c22124.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c22124.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c22124.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsSetCard(0x813) then
			c22124[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
function c22124.clear(e,tp,eg,ep,ev,re,r,rp)
	c22124[0]=true
	c22124[1]=true
end
function c22124.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c22124[tp] end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c22124.splimit)
	e1:SetLabelObject(e)
	Duel.RegisterEffect(e1,tp)
end
function c22124.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return e:GetLabelObject()~=se and not c:IsSetCard(0x813)
end
function c22124.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22125,0x813,0x4011,500,500,1,RACE_ZOMBIE,ATTRIBUTE_DARK)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c22124.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22125,0x813,0x4011,500,500,1,RACE_ZOMBIE,ATTRIBUTE_DARK) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,22124+i)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(c22124.recon)
			token:RegisterEffect(e1,true)
		end
		Duel.SpecialSummonComplete()
	end
end
function c22124.recon(e,c)
	return not c:IsSetCard(0x813)
end
