--不自然的冷气✿琪露诺
function c999505.initial_effect(c)
	--lvup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(999505,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c999505.lvcost)
	e1:SetTarget(c999505.lvtg)
	e1:SetOperation(c999505.lvop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999505,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e2:SetCountLimit(1,999505)
	e2:SetCondition(c999505.spcon)
	e2:SetTarget(c999505.sptg)
	e2:SetOperation(c999505.spop)
	c:RegisterEffect(e2)
end

function c999505.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

function c999505.lvfilter(c,tp)
	return c:IsSetCard(0x999) and c:GetControler()==tp and c:IsFaceup() and not c:IsType(TYPE_XYZ)
end

function c999505.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c999505.lvfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c999505.lvfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c999505.lvfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end

function c999505.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(3)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end

function c999505.cfilter(c,tp)
	return c:IsSetCard(0x999) and c:GetLevel()==2
end

function c999505.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c999505.cfilter,1,nil,tp)
end

function c999505.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c999505.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE))then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end