 
--爱莲的宠物 苏格拉底
function c13005.initial_effect(c)
	c:SetUniqueOnField(1,0,13005)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCondition(c13005.spcon)
	e1:SetOperation(c13005.spop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13005,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c13005.eqtg)
	e2:SetOperation(c13005.eqop)
	c:RegisterEffect(e2)
	--unequip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13005,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c13005.uncon)
	e3:SetTarget(c13005.sptg)
	e3:SetOperation(c13005.espop)
	c:RegisterEffect(e3)
	--destroy sub
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e4:SetCondition(c13005.uncon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--eqlimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EQUIP_LIMIT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(aux.TargetBoolFunction(Card.IsCode,13001))
	c:RegisterEffect(e5)
end
function c13005.spfilter1(c,tp)
	return c:IsFaceup() and c:IsCode(13001)
		and Duel.IsExistingMatchingCard(c13005.spfilter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c13005.spfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c13005.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c13005.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c13005.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c13005.spfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
	Duel.ShuffleDeck(tp)
end
function c13005.uncon(e)
	return e:GetHandler():IsStatus(STATUS_UNION)
end
function c13005.filter(c)
	return c:IsFaceup() and c:IsCode(13001) and c:GetUnionCount()==0
end
function c13005.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c13005.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(13005)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c13005.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c13005.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(13005,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c13005.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c13005.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	c:SetStatus(STATUS_UNION,true)
end
function c13005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(13005)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(13005,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c13005.espop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)
	end
end
