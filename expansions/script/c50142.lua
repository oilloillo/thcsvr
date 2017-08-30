 
--古鹰型重巡洋舰-古鹰
function c50142.initial_effect(c)
	local temp = 0
	while temp<4 do
		c:RegisterFlagEffect(50200,0,0,0)
		temp = temp+1
	end
	--summon with no tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50142,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c50142.ntcon)
	e2:SetOperation(c50142.ntop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50142,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCost(c50142.descost)
	e3:SetTarget(c50142.destg)
	e3:SetOperation(c50142.desop)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(aux.FALSE)
	c:RegisterEffect(e4)
end
function c50142.ntcon(e,c)
	if c==nil then return true end
	return c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.CheckLPCost(tp,500)
end
function c50142.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,500)
end
function c50142.cfilter(c)
	return c:IsSetCard(0x4bb)
end
function c50142.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c50142.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c50142.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c50142.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsDestructable() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c50142.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
