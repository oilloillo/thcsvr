 
--星莲-水难念缚灵 村纱水蜜
function c26005.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26005,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c26005.ntcon)
	e1:SetOperation(c26005.ntop)
	c:RegisterEffect(e1)
	--level up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26005,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c26005.target)
	e2:SetOperation(c26005.operation)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26005,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c26005.condition)
	e3:SetTarget(c26005.sptg)
	e3:SetOperation(c26005.spop)
	c:RegisterEffect(e3)
end
function c26005.ntcon(e,c)
	if c==nil then return true end
	return c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c26005.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c26005.filter1(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsLevelBelow(7)
end
function c26005.filter2(c)
	return c:IsFaceup() and not c:IsType(TYPE_XYZ) and c:IsSetCard(0x251)
end
function c26005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c26005.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26005.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c26005.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c26005.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c26005.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(c26005.filter2,tp,LOCATION_MZONE,0,nil)
		local lc=g:GetFirst()
		local lv=tc:GetLevel()
		while lc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			lc:RegisterEffect(e1)
			lc=g:GetNext()
		end
	end
end
function c26005.condition(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.GetFlagEffect(tp,26005)==0) then Duel.RegisterFlagEffect(tp,26005,RESET_PHASE+PHASE_END,0,0)
		else return false end
	return Duel.GetFlagEffect(tp,26005)==1
end
function c26005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26005.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c26005.filter(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN)
end
function c26005.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c26005.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENCE)
		Duel.ConfirmCards(1-tp,sg)
	end
end
