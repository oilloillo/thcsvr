 
--剑精灵-护界神‧爱思特
function c40016.initial_effect(c)
	c:SetUniqueOnField(1,0,40016)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40016,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c40016.sptg)
	e1:SetOperation(c40016.spop)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40016,2))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c40016.target)
	e2:SetOperation(c40016.operation)
	c:RegisterEffect(e2)
	--defup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c40016.con)
	e3:SetTarget(aux.TargetBoolFunction(aux.TRUE))
	e3:SetValue(-1000)
	c:RegisterEffect(e3)
end
function c40016.con(e)
	return e:GetHandler():IsAttackPos()
end
function c40016.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x430) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c40016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) 
		and Duel.IsExistingMatchingCard(c40016.spfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c40016.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c40016.tcfilter(c)
	return c:IsFaceup() and (c:IsCode(40001) or c:IsCode(40029))
end
function c40016.eqfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsCode(40034)
end
function c40016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsControler(tp) and c40016.tcfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsReleasable()
		and Duel.IsExistingTarget(c40016.tcfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetCurrentPhase()==PHASE_BATTLE
		and Duel.IsExistingMatchingCard(c40016.eqfilter,tp,0x13,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40016,1))
	Duel.SelectTarget(tp,c40016.tcfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c40016.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c40016.eqfilter,tp,0x13,0,1,1,nil)
		if g:GetCount()>0 and Duel.Release(e:GetHandler(),REASON_EFFECT)>0 then
			Duel.Equip(tp,g:GetFirst(),tc)
		end
	end
end
