--濑笈叶
function c999001.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetDescription(aux.Stringid(999001,0))
	e1:SetCountLimit(1,9990011+EFFECT_COUNT_CODE_DUEL)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c999001.condition)
	e1:SetTarget(c999001.target)
	e1:SetOperation(c999001.operation)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RECOVER)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9990012)
	e2:SetCondition(c999001.spcon)
	e2:SetTarget(c999001.sptg)
	e2:SetOperation(c999001.spop)
	c:RegisterEffect(e2)
end

function c999001.condition(e,tp,eg,ep,ev,re,r,rp)
	local hp1=Duel.GetLP(tp)
	local hp2=Duel.GetLP(1-tp)
	return hp1<8000 and hp2-hp1>=3000
end

function c999001.filter(c)
	return c:IsDestructable() and c:IsAbleToRemove()
		and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end

function c999001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local hp1=Duel.GetLP(tp)
	local hp2=Duel.GetLP(1-tp)
	if chk==0 then return hp1<8000 and hp2-hp1>=3000 end
	if hp1<8000 then Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,8000-hp1) end
	if hp2<8000 then Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,8000-hp2) end
end

function c999001.operation(e,tp,eg,ep,ev,re,r,rp)
	local hp1=Duel.GetLP(tp)
	local hp2=Duel.GetLP(1-tp)
	if hp1<8000 then Duel.Recover(tp,8000-hp1,REASON_EFFECT) end
	if hp2<8000 then Duel.Recover(1-tp,8000-hp2,REASON_EFFECT) end
end

function c999001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end

function c999001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and c:IsLocation(LOCATION_GRAVE)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c999001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			c:RegisterEffect(e2)
		end
	end
end