--最凶极恶的双子姐妹✿幻月
function c14062.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14062,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c14062.spcon)
	e1:SetTarget(c14062.sptg)
	e1:SetOperation(c14062.spop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c14062.atkvalp)
	c:RegisterEffect(e2)
	--attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c14062.atkval)
	c:RegisterEffect(e3)
end
function c14062.cfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM and c:IsSetCard(0x138)
end
function c14062.spcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	if not tc or not tc:IsCode(14061) then return end
	return ep==tp and eg:FilterCount(c14062.cfilter,nil)>0
end
function c14062.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c14062.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c14062.atkvalp(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)*200
end
function c14062.atkfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x208) 
end
function c14062.atkval(e,c)
	local g=Duel.GetMatchingGroup(c14062.atkfilter,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil)
	return g:GetClassCount(Card.GetCode)*200
end
