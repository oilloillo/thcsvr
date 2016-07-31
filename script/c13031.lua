 
--女仆机器人 留琴
function c13031.initial_effect(c)
	--Set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	--Trap
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EFFECT_CHANGE_TYPE)
	e2:SetValue(TYPE_TRAP)
	--c:RegisterEffect(e2)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13031,0))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c13031.eqcon)
	e4:SetCost(c13031.eqcost)
	e4:SetTarget(c13031.eqtg)
	e4:SetOperation(c13031.operation)
	c:RegisterEffect(e4)
	--unequip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(13031,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c13031.uncon)
	e5:SetTarget(c13031.sptg)
	e5:SetOperation(c13031.spop)
	c:RegisterEffect(e5)
	--equip effect
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetValue(500)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_EQUIP)
	e7:SetCode(EFFECT_UPDATE_DEFENCE)
	e7:SetValue(500)
	c:RegisterEffect(e7)
end
function c13031.eqlimit(e,c)
	return c:IsSetCard(0x100) or c:IsCode(13021)
end
function c13031.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,0x41)==0x41
end
function c13031.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,13031)<2 end
	Duel.RegisterFlagEffect(tp,13031,RESET_PHASE+PHASE_END,0,1)
end
function c13031.eqfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x100) or c:IsCode(13021))
end
function c13031.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c13031.eqfilter(chkc) end
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c13031.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c13031.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c13031.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c13031.eqlimit)
	c:RegisterEffect(e1)
	end
end
function c13031.uncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()~=0
end
function c13031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c13031.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
