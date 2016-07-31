 
--妖魔书变化 邪龙
function c21470016.initial_effect(c)
	--synchro summon
	c21470016.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2742),aux.NonTuner(nil),1,aux.Stringid(21470016,1))
	c21470016.AddSynchroProcedure(c,nil,aux.NonTuner(aux.FilterBoolFunction(Card.IsSetCard,0x2742)),1,aux.Stringid(21470016,2))
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21470016,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c21470016.setcon)
	e1:SetCost(c21470016.setcost)
	e1:SetTarget(c21470016.settg)
	e1:SetOperation(c21470016.setop)
	c:RegisterEffect(e1)
	--AtkDef
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c21470016.atkval)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENCE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c21470016.atkval)
	c:RegisterEffect(e1)
	--[[
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE_START+PHASE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c21470016.imop)
	c:RegisterEffect(e4)]]		
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c21470016.tgcon)
	e1:SetValue(c21470016.imfilter)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
end
function c21470016.afilter(c)
	return c:IsSetCard(0x742) and c:IsFaceup()
end
function c21470016.atkval(e,c)
	return Duel.GetMatchingGroupCount(c21470016.afilter,c:GetControler(),LOCATION_ONFIELD,0,nil)*300
end
function c21470016.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c21470016.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c21470016.sfilter(c)
	return c:IsSetCard(0x742) and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable()
end
function c21470016.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c21470016.sfilter,tp,LOCATION_DECK,0,1,nil)) end
end
function c21470016.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c21470016.sfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then 
		Duel.SSet(tp,tc) 
		Duel.ConfirmCards(1-tp,tc)
		tc:RegisterFlagEffect(21470020,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)	
	end
end--[[
function c21470016.imop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c21470016.imfilter)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	e:GetHandler():RegisterEffect(e1)
end]]
function c21470016.tgcon(e)
	return Duel.GetCurrentPhase()==PHASE_BATTLE or Duel.GetCurrentPhase()==PHASE_DAMAGE or Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
end
function c21470016.imfilter(e,te)
	return not te:GetHandler():IsSetCard(0x742)
end
function c21470016.AddSynchroProcedure(c,f1,f2,ct,desc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetDescription(desc)
	e1:SetCondition(Auxiliary.SynCondition(f1,f2,ct,99))
	e1:SetTarget(Auxiliary.SynTarget(f1,f2,ct,99))
	e1:SetOperation(Auxiliary.SynOperation(f1,f2,ct,99))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
end
function c21470016.SynCondition(f1,f2,minc,maxc)
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
function c21470016.SynOperation(f1,f2,minc,maxc)
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