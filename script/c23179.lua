--诅咒之地
function c23179.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PLANT))
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c23179.val1)
	c:RegisterEffect(e2)
	--Def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_DEFENCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PLANT))
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(c23179.val2)
	c:RegisterEffect(e3)
	--dice
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(23179,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c23179.target)
	e4:SetOperation(c23179.operation)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function c23179.val1(e,c)
	return c:GetAttack()/2
end
function c23179.val2(e,c)
	return c:GetDefence()/2
end
function c23179.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c23179.cfilter,1,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c23179.cfilter(c,sp)
	return c:IsRace(RACE_PLANT) and c:IsFaceup() and c:GetControler()==sp and c:GetLevel()<=7
end
function c23179.filter(c,sp,e)
	return c:IsRace(RACE_PLANT) and c:IsFaceup() and c:GetControler()==sp and c:GetLevel()<=7 and c:IsDestructable() and c:IsRelateToEffect(e)
end
function c23179.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local dc=Duel.TossDice(tp,1)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c23179.filter,nil,tp,e)
	if dc<5 and g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	else
		Duel.Damage(tp,2000,REASON_EFFECT)
	end
end
