 
--妖魔书变化 百鬼夜行
function c21470015.initial_effect(c)
	--synchro summon
	c21470015.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2742),aux.NonTuner(nil),1,aux.Stringid(21470015,2))
	c21470015.AddSynchroProcedure(c,nil,aux.NonTuner(aux.FilterBoolFunction(Card.IsSetCard,0x2742)),1,aux.Stringid(21470015,3))
	c:EnableReviveLimit()
	--[[cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2)]]--[[
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11021,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c21470015.destg)
	e1:SetOperation(c21470015.desop)
	c:RegisterEffect(e1)]]
	--turnset
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21470015,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c21470015.tg)
	e1:SetOperation(c21470015.op)
	c:RegisterEffect(e1)
	--[[AtkDef
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c21470015.atkval)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENCE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c21470015.atkval)
	c:RegisterEffect(e1)]]
	--negdes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21470015,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c21470015.condition)
	e1:SetCost(c21470015.cost)
	e1:SetTarget(c21470015.target)
	e1:SetOperation(c21470015.operation)
	c:RegisterEffect(e1,tp)
end
function c21470015.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if c~=Duel.GetAttacker() then return false end
	if chk==0 then return tc==nil or tc:IsFaceup() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function c21470015.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if (tc==nil or tc:IsFaceup()) and c:IsRelateToBattle() then Duel.Destroy(c,REASON_EFFECT) end
end
function c21470015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,21470015)<=0 end
	Duel.RegisterFlagEffect(tp,21470015,RESET_PHASE+PHASE_END,0,1)
end--[[
function c21470015.afilter(c)
	return c:IsSetCard(0x742) and c:IsFaceup()
end
function c21470015.atkval(e,c)
	return Duel.GetMatchingGroupCount(c21470015.afilter,c:GetControler(),LOCATION_MZONE,0,nil)*200
end]]
function c21470015.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanTurnSet()
end
function c21470015.filter2(c)
	return c:IsSetCard(0x742) and c:IsCanTurnSet()
end
function c21470015.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c21470015.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21470015.filter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c21470015.filter2,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=Duel.SelectTarget(tp,c21470015.filter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tg=Duel.SelectTarget(tp,c21470015.filter,tp,0,LOCATION_MZONE,1,1,nil)
	if sg:GetFirst():IsType(TYPE_MONSTER) then tg:Merge(sg) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tg,tg:GetCount(),0,0)
end
function c21470015.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sc=tg:GetFirst()
	local tc=tg:GetNext()
	if sc:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and sc:IsFaceup() and tc:IsFaceup() then
		if sc:IsType(TYPE_MONSTER) then 
			if sc:IsType(TYPE_TRAPMONSTER) then 
				Duel.ChangePosition(tg,POS_FACEDOWN_DEFENCE) 
				sc:RegisterFlagEffect(21470020,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			else Duel.ChangePosition(tg,POS_FACEDOWN_DEFENCE) end
		else 
			Duel.ChangePosition(sc,POS_FACEDOWN)
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENCE)
			Duel.RaiseEvent(sc,EVENT_SSET,e,REASON_EFFECT,tp,tc:GetControler(),0) 
			sc:RegisterFlagEffect(21470020,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)			
		end
	end
end
function c21470015.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) or --not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or 
	not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
--	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_POSITION)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0 --and g and g:IsContains(c)
end
function c21470015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c21470015.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.NegateActivation(ev) then Duel.Destroy(tc,REASON_EFFECT) end
end
function c21470015.AddSynchroProcedure(c,f1,f2,ct,desc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetDescription(desc)
	e1:SetCondition(c21470015.SynCondition(f1,f2,ct,99))
	e1:SetOperation(c21470015.SynOperation(f1,f2,ct,99))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
end
function c21470015.SynCondition(f1,f2,minc,maxc)
	return	function(e,c,tuner)
				if c==nil then return true end
				local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
				local ct=-ft
				if minc<ct then minc=ct end
				if maxc<minc then return false end
				if tuner then return Duel.CheckTunerMaterial(c,tuner,f1,f2,minc,maxc) end
				return Duel.CheckSynchroMaterial(c,f1,f2,minc,maxc)
			end
end
function c21470015.SynOperation(f1,f2,minc,maxc)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,tuner)
				local g=nil
				local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
				local ct=-ft
				if minc<ct then minc=ct end
				if tuner then
					g=Duel.SelectTunerMaterial(c:GetControler(),c,tuner,f1,f2,minc,maxc)
				else
					g=Duel.SelectSynchroMaterial(c:GetControler(),c,f1,f2,minc,maxc)
				end
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
			end
end