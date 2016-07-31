 
--博丽灵梦
function c10001.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10001.spcon)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c10001.atkcon)
	e2:SetValue(c10001.atkval)
	c:RegisterEffect(e2)
end
function c10001.spfilter(c)
	return c:IsFaceup() and c:IsCode(10000)
end
function c10001.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c10001.spfilter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c10001.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()) and Duel.GetAttackTarget()~=nil
end
function c10001.atkval(e,c)
	return e:GetHandler():GetBattleTarget():GetLevel()*100
end