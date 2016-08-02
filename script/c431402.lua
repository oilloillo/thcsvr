--甘兔庵
function c431402.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c431402.tfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c431402.regcon)
	e1:SetOperation(c431402.regop)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c431402.sumop)
	c:RegisterEffect(e2)
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(431402,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c431402.hdcon)
	e3:SetCost(c431402.hdcost)
	e3:SetTarget(c431402.hdtg)
	e3:SetOperation(c431402.hdop)
	c:RegisterEffect(e3)
end
function c431402.tfilter(c)
	return c:IsSetCard(0x404) or c:IsHasEffect(421408)
end
function c431402.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c431402.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c431402.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c431402.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(431402) and bit.band(sumtype,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c431402.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,431402)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x404))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,431402,RESET_PHASE+PHASE_END,0,1)
end
function c431402.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c431402.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsLevelBelow,1,e:GetHandler(),3) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsLevelBelow,1,10,e:GetHandler(),3)
	local ct=Duel.Release(g,REASON_COST)
	e:SetLabel(ct)
end
function c431402.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,e:GetLabel())
end
function c431402.hdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
end