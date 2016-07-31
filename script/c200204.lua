 
--符器-白楼剑
function c200204.initial_effect(c)
	--act
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_START,0)
--	e1:SetCost(c200204.cost)
	e1:SetTarget(c200204.target)
	e1:SetOperation(c200204.op)
	c:RegisterEffect(e1)
	if not c200204.global_check then
		c200204.global_check=true--[[
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c200204.checkop)
		Duel.RegisterEffect(ge1,0)]]
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c200204.check)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ATTACK_DISABLED)
		ge2:SetOperation(c200204.check2)
		Duel.RegisterEffect(ge2,0)
	end
end--[[
function c200204.checkop(e,tp,eg,ep,ev,re,r,rp)
	local p1=nil
	local p2=nil
	local tc=eg:GetFirst()
	while tc do
		if tc:IsPreviousLocation(LOCATION_DECK+LOCATION_EXTRA) then
			if tc:GetSummonPlayer()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,c200204,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,c200204,RESET_PHASE+PHASE_END,0,1) end
end]]
function c200204.check(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=tc:GetFlagEffectLabel(200204)
	if ct then
		tc:SetFlagEffectLabel(200204,ct+1)
	else
		tc:RegisterFlagEffect(200204,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,1)
	end
end
function c200204.check2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=tc:GetFlagEffectLabel(200204)
	if ct then
		tc:SetFlagEffectLabel(200204,ct-1)
	end
end--[[
function c200204.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,c200204)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c200204.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end]]
function c200204.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_DECK+LOCATION_EXTRA)
end
function c200204.filter(c)
	local ct=c:GetFlagEffectLabel(200204)
	return c:IsFaceup() and c:IsSetCard(0x208) and ct and ct>0
end
function c200204.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return tp==Duel.GetTurnPlayer() and Duel.GetCurrentPhase()==PHASE_BATTLE 
	and Duel.IsExistingTarget(c200204.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c200204.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c200204.op(e,tp,eg,ep,ev,re,r,rp)	
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		--reduce
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e3:SetOperation(c200204.rdop)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		--[[
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetLabelObject(tc)
		e1:SetValue(c200204.damval)
		e1:SetReset(RESET_PHASE+PHASE_END,1)
		Duel.RegisterEffect(e1,tp)]]
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_EXTRA_ATTACK)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
	end
end
function c200204.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end--[[
function c200204.damval(e,re,val,r,rp,rc)
	if (rc==e:GetLabelObject()) or (re and re:GetHandler()==e:GetLabelObject())
	or (re and re:GetHandler():GetCode()==200102 and (Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL) or (Duel.GetCurrentPhase()==PHASE_DAMAGE)
	and Duel.GetAttacker() and Duel.GetAttacker()==e:GetLabelObject()) 
	then return val/2
	else return val end
end]]