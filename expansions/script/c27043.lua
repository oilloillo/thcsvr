--穿墙的邪仙✿霍青娥
function c27043.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,27043)
	e1:SetCondition(c27043.spcon)
	e1:SetOperation(c27043.spop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetRange(LOCATION_HAND)
	c:RegisterEffect(e3)
    --direct atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--synchro summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(c27043.synlimit)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(27043,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetTarget(c27043.target)
	e5:SetOperation(c27043.operation)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function c27043.synlimit(e,c)
	if not c then return false end
	if c:IsSetCard(0x5208) then
	return else return not c:IsSetCard(0x120) end
end
function c27043.spfilter(c)
	return c:IsFaceup() and c:IsAbleToHandAsCost() and c:IsSetCard(0x208) and (c:IsRace(RACE_ZOMBIE) or c:IsRace(RACE_ROCK))
	-- and not c:IsCode(27043)
end
function c27043.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c27043.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c27043.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c27043.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c27043.filter(c,e,tp)
	return c:IsSetCard(0x242) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c27043.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetPreviousLocation()==LOCATION_HAND
		and Duel.IsExistingMatchingCard(c27043.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x12)
end
function c27043.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c27043.filter,tp,0x12,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
