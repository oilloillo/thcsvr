 
--邪眼西格玛
function c12012.initial_effect(c)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12012,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c12012.geqtg)
	e3:SetOperation(c12012.geqop)
	c:RegisterEffect(e3)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12012,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c12012.eqtg)
	e2:SetOperation(c12012.eqop)
	c:RegisterEffect(e2)
	--unequip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12012,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c12012.uncon)
	e3:SetTarget(c12012.sptg)
	e3:SetOperation(c12012.espop)
	c:RegisterEffect(e3)
	--destroy sub
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e4:SetCondition(c12012.uncon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--eqlimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EQUIP_LIMIT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(aux.TargetBoolFunction(Card.IsCode,12014))
	c:RegisterEffect(e5)
end
function c12012.geqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c12012.filter(chkc) end
	if chk==0 then return Duel.GetFlagEffect(tp,12012)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c12012.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c12012.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.RegisterFlagEffect(tp,12012,RESET_PHASE+PHASE_END,0,1)
end
function c12012.geqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	c:SetStatus(STATUS_UNION,true)
end
function c12012.uncon(e)
	return e:GetHandler():IsStatus(STATUS_UNION)
end
function c12012.filter(c)
	return c:IsFaceup() and c:IsCode(12014) and c:GetUnionCount()==0
end
function c12012.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c12012.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(12012)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c12012.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c12012.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(12012,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c12012.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c12012.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	c:SetStatus(STATUS_UNION,true)
end
function c12012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(12012)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(12012,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c12012.espop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)
	end
end
