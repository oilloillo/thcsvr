--太阳花田
function c25147.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetDescription(aux.Stringid(25147,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c25147.sptg)
	e2:SetOperation(c25147.spop)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(25147,2))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_REPEAT)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c25147.rtg)
	e3:SetOperation(c25147.rop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(25147,1))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c25147.destg)
	e4:SetOperation(c25147.desop)
	c:RegisterEffect(e4)
	if not c25147.global_check then
		c25147.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c25147.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c25147.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c25147.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsRace(RACE_PLANT) then
			c25147[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
function c25147.clear(e,tp,eg,ep,ev,re,r,rp)
	c25147[0]=true
	c25147[1]=true
end
function c25147.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	if chk==0 then return c25147[tp] and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ct>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,25160,0x208,0x4011,1000,1000,1,RACE_PLANT,ATTRIBUTE_LIGHT) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c25147.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,0,0)
end
function c25147.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_PLANT)
end
function c25147.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	if ct<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,25160,0x208,0x4011,1000,1000,1,RACE_PLANT,ATTRIBUTE_WIND) then
		for i = 1,ct do
			local token=Duel.CreateToken(tp,25160)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			-- local e2=Effect.CreateEffect(e:GetHandler())
			-- e2:SetType(EFFECT_TYPE_SINGLE)
			-- e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			-- e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			-- e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			-- e2:SetValue(1)
			-- token:RegisterEffect(e2,true)
			-- local e4=Effect.CreateEffect(e:GetHandler())
			-- e4:SetType(EFFECT_TYPE_SINGLE)
			-- e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			-- e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			-- e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			-- e4:SetValue(1)
			-- token:RegisterEffect(e4,true)
		end
		Duel.SpecialSummonComplete()
	end
end
function c25147.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetTurnPlayer()==tp and e:GetHandler():GetCounter(0x208)>0 end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c25147.rop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=e:GetHandler():GetCounter(0x208)
	Duel.Recover(tp,ct*500,REASON_EFFECT)
end
function c25147.filter(c)
	return c:IsRace(RACE_PLANT) and c:IsDestructable() and c:IsType(TYPE_TOKEN)
end
function c25147.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c25147.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c25147.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c25147.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c25147.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		e:GetHandler():AddCounter(0x208,1)
	end
end
