 
--暗精灵-蕾斯提亚
function c40019.initial_effect(c)
	c:SetUniqueOnField(1,0,40019)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40019,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c40019.spcon)
	e1:SetTarget(c40019.sptg)
	e1:SetOperation(c40019.spop)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40019,2))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c40019.target)
	e2:SetOperation(c40019.operation)
	c:RegisterEffect(e2)
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetCondition(c40019.atcon)
	c:RegisterEffect(e3)
end
function c40019.atcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>1
end
function c40019.spfilter(c,tp)
	return c:IsSetCard(0x430) and c:IsType(TYPE_MONSTER) and c:GetControler()==tp
		and bit.band(c:GetReason(),0x41)==0x41 and c:GetLocation()==LOCATION_MZONE
end
function c40019.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40019.spfilter,1,nil,e:GetHandler():GetControler())
end
function c40019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c40019.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c40019.tcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x430) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c40019.eqfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsCode(40035)
end
function c40019.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsControler(tp) and c40019.tcfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsReleasable()
		and Duel.IsExistingTarget(c40019.tcfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetCurrentPhase()==PHASE_BATTLE
		and Duel.IsExistingMatchingCard(c40019.eqfilter,tp,0x13,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40019,1))
	Duel.SelectTarget(tp,c40019.tcfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c40019.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c40019.eqfilter,tp,0x13,0,1,1,nil)
		if g:GetCount()>0 and Duel.Release(e:GetHandler(),REASON_EFFECT)>0 then
			Duel.Equip(tp,g:GetFirst(),tc)
		end
	end
end
